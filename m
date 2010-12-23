Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab0LWFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:41:43 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:49752 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0LWFlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:41:42 -0500
Message-ID: <4D12E111.5040207@afaics.de>
Date: Thu, 23 Dec 2010 06:41:37 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Intel 82915G/GV/910GL, 2.6.36.2: problem with CONFIG_DRM_I915_KMS=y
References: <4D0A9164.5070503@afaics.de> <AANLkTi=jeJriExzNVRxbApz9VEUeuL0BpVLnRoTx_SrT@mail.gmail.com> <5b55a1$ivogvh@fmsmga002.fm.intel.com> <4D0CAEE4.7080309@afaics.de>
In-Reply-To: <4D0CAEE4.7080309@afaics.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

On 12/18/10 13:53, Harald Dunkel wrote:
> On 12/17/10 02:15, Chris Wilson wrote:
> 
>> Sounds like:
> 
>> commit 47f1c6c9ffdec0c0e5a2c2709bd63c7380b325c4
> 
> I tried 2.6.37-rc6 (which includes this patch): The problem is gone.
> 

Sorry to say, but that was a mistake. By accident CONFIG_DRM_I915_KMS
was _not_ set. I just noticed when I tried rc7.

rc7 built with CONFIG_DRM_I915_KMS=yes still boots into a blank screen.


My apologies for the bad confirmation message. Please mail if I can
help.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0S4QwACgkQUTlbRTxpHjcy1ACcCOof3+AlZxz6LFWvSWtL6T6d
9PAAnjUizmYG1D23VjzYnS86W14S3Vxd
=ZJpb
-----END PGP SIGNATURE-----
