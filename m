Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220Ab1IOWH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:07:26 -0400
Received: from exout101.netflix.com ([69.53.237.162]:21590 "EHLO
	exout101.netflix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1IOWHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:07:25 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 18:07:25 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024;d=netflix.com;
  h=from:to:date:subject:message-id:content-type:mime-version;
  b=dKC80ok+QSi+iIKLyFAOt3B6cHfIkVDnQN2e7ycnfvWF9LchOvFhPuut2j8pk+RwrAvf3jCc
    Px1TeUlNo0FsJkVfoUf8rnVDU5lUx448Q+2CQujG7wPKSbmn5KdM0xzmzLSnjNyz7yp4CGL4
    8dqw1uOBx4hMhx9gF8oN1NR777Q=
From: Wesley Miaw <wmiaw@netflix.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Sep 2011 15:02:18 -0700
Subject: Re: [PATCH] dm: verity target
Thread-Topic: [PATCH] dm: verity target
Thread-Index: Acxz8yMooADs1JM/T0yS1tVxxBVR6Q==
Message-ID: <48F0EA4A-5982-4686-8492-422F4225D5FB@netflix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011 Sep 15, at 11:45 AM, Mandeep Singh Baines wrote:

> The verity target provides transparent integrity checking of block devices
> using a cryptographic digest.
> 
> dm-verity is meant to be setup as part of a verified boot path.  This
> may be anything ranging from a boot using tboot or trustedgrub to just
> booting from a known-good device (like a USB drive or CD).
> 
> dm-verity is part of ChromeOS's verified boot path. It is used to verify
> the integrity of the root filesystem on boot. The root filesystem is
> mounted on a dm-verity partition which transparently verifies each block
> with a bootloader verified hash passed into the kernel at boot.

Netflix would like dm-verity to be included in the Linux kernel. Over the past year, we have been working with Google and porting dm-verity onto a number of consumer electronics devices running embedded Linux. Demand for this feature has been high and we see a lot of benefit associated with making dm-verity part of the official kernel.
--
Wesley Miaw
