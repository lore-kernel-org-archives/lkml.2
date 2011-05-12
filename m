Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1ELOSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:18:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab1ELOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Um6C8W82RrYDd8HXlcAyrqQIVOXLwYpUjzIHNYK4MNq4rnANFgGqjLL8luLVV1Fuav
         AmK1tmpu4GU0QLccAthmGXHVj+bpJNX12vOg86fSW+RHtCRgHDiOZjA1XODTYqamFiYk
         QBn2DkHCT2/8NZpLhfJIZ1L6NPI25t83ACAz4=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
Date: Thu, 12 May 2011 22:18:29 +0800
Message-ID: <BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: chenxi <chenxi05@baidu.com>, Maxin B John <maxin.john@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 7:16 PM, Daniel Baluta <daniel.baluta@gmail.com> wrote:
>
> Can you please remove your module?
> I think the memory is leaked at unload time.
>

No, in kmemleak-test.c we have same examples.

chenxi, I assume you didn't edit the .config manually?
