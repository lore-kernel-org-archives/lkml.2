Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1D1R4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:56:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56049 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab1D1R4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <4DB9A5D9.7030607@schaufler-ca.com>
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
	<4DB87A6B.7060805@schaufler-ca.com>
	<20110427232718.GG30854@boyd.l.tihix.com>
	<201104281435.08273.roberto.sassu@polito.it>
	<4DB9A5D9.7030607@schaufler-ca.com>
Date: Thu, 28 Apr 2011 13:56:03 -0400
Message-ID: <BANLkTimgn19+T4uFmNgjD1bqVYV3q-3sMA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
From: Eric Paris <eparis@parisplace.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        eparis@redhat.com, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        viro@zeniv.linux.org.uk, john.johansen@canonical.com,
        apparmor@lists.ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 1:37 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 4/28/2011 5:35 AM, Roberto Sassu wrote:
>> On Thursday, April 28, 2011 01:27:19 AM Tyler Hicks wrote:
>>> On Wed Apr 27, 2011 at 01:19:55PM -0700, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> On 4/27/2011 5:34 AM, Roberto Sassu wrote:

> On this point I most strongly disagree.


Casey, I'm glad you're trying to figure out what's going on here
because I certainly don't understand all the problems!

If there were some mechanism by which the 'lower' inode could be ONLY
accessibly by ecyptfs kernel internals it oculd be marked IS_PRIVATE
and skip all security checks on it.  Then you only have SELinux
security checks on the upper inode.  Which seems to make sense.  My
problem is that this is ONLY acceptable if there is no way for
userspace to directly reference the lower struct inode.

Just a thought.

-Eric
