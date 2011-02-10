Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1BJQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:08:56 -0500
Received: from sous-sol.org ([216.99.217.87]:57407 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756361Ab1BJQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:08:54 -0500
Date: Thu, 10 Feb 2011 08:08:37 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] security: add cred argument to security_capable()
Message-ID: <20110210160837.GB9869@sequoia.sous-sol.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
 <1297318312-14309-2-git-send-email-chrisw@sous-sol.org>
 <4D540BCE.5020007@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D540BCE.5020007@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> On 2/9/2011 10:11 PM, Chris Wright wrote:
> > Expand security_capable() to include cred, so that it can be usable in a
> > wider range of call sites.
> 
> I'll bite. What to plan to use this for? I wouldn't see this getting
> accepted on its own without a user. I don't see anything wrong with
> the change other than that it is not used by anything.

Casey, the user is in 2/2.

https://lkml.org/lkml/2011/2/10/16
