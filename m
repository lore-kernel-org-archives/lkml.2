Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1BNTdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:33:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54603 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1BNTdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jBpfKAEvF0oQwU58/5RdyMD/2F8AHgsJxcJCwksTTCmWokNwInpTqVt27ASnE7rSro
         MT96BCmEGbWrvYR5+3j/b8BckPDTfMtLtBj4StDz8gw5vLxLyOAhxtMMcAdC1ik1YAsL
         Ab+9U1aHDWFtInHC9h/Ha1H7WAhXy7OGaqoXI=
MIME-Version: 1.0
In-Reply-To: <658335B0-9138-4293-9E25-B557AE0DEF7A@redhat.com>
References: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
 <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com>
 <1296587121.12605.30.camel@moss-pluto> <658335B0-9138-4293-9E25-B557AE0DEF7A@redhat.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 14 Feb 2011 21:33:25 +0200
Message-ID: <AANLkTimGVCCTVjdw3ODPDGHF9bdJMPUz4JR=1oG86EtF@mail.gmail.com>
Subject: Re: [PATCH 2/2] security: remove unused security_sysctl hook
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 10:06 PM, Eric Paris <eparis@redhat.com> wrote:
>
>
>
>
> On Feb 1, 2011, at 2:05 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
>> On Tue, 2011-02-01 at 18:44 +0200, Lucian Adrian Grijincu wrote:
>>> The only user for this hook was selinux. sysctl routes every call
>>> through /proc/sys/. Selinux and other security modules use the file
>>> system checks for sysctl too, so no need for this hook any more.
>>>
>>> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
>>
>> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
>
> I've applied both to the selinux tree. Thanks


I've checked both these trees (on all published branches):
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
  git://git.infradead.org/users/eparis/selinux.git

and there's no trace of these patches.


Am I not looking in the right places for these patches?

-- 
 .
..: Lucian
