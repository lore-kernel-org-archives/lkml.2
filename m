Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1BNUGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:06:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BNUGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OhxNEyv/rDgY6b7uluWHKDujbOPSnbawwX7AUIuNaSGjVraBM9IUn9To5OxXhB3iGk
         mwbUewWiKBFRhkdLenaAEGZOyuPMgfmN9QaJ11kNkl3Dz5BY0/9nZsaTgGpT258bq9Js
         KK5Ew4nH+ylc6RNAaOGzzfiD9FVXbmDOClsKc=
MIME-Version: 1.0
In-Reply-To: <1297713227.2783.30.camel@unknown001a4b0c2895>
References: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
 <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com>
 <1296587121.12605.30.camel@moss-pluto> <658335B0-9138-4293-9E25-B557AE0DEF7A@redhat.com>
 <AANLkTimGVCCTVjdw3ODPDGHF9bdJMPUz4JR=1oG86EtF@mail.gmail.com> <1297713227.2783.30.camel@unknown001a4b0c2895>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 14 Feb 2011 22:06:20 +0200
Message-ID: <AANLkTi=WGBDyGpuCjUjuYj=E6HRc80+iunJ_PdXeJq5G@mail.gmail.com>
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

On Mon, Feb 14, 2011 at 9:53 PM, Eric Paris <eparis@redhat.com> wrote:
>> >> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>


FWIW you forgot Stephen's Acked-by.


>> I've checked both these trees (on all published branches):
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
>>   git://git.infradead.org/users/eparis/selinux.git
>>
>> and there's no trace of these patches.
>>
>>
>> Am I not looking in the right places for these patches?
>
> The second one is the right tree, I just forgot to push!  Pushed now!


MAINTAINERS says:
SELINUX SECURITY MODULE
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git

Should It be changed to point to your tree? Or should a new entry be
added to point to your tree?

-- 
 .
..: Lucian
