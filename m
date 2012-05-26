Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2EZI3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:29:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2EZI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:29:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Date: Sat, 26 May 2012 08:29:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
References: <201205260739.31653.arnd@arndb.de> <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com> <20120526075855.GA1702@mail.gnudd.com>
In-Reply-To: <20120526075855.GA1702@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205260829.19232.arnd@arndb.de>
X-Provags-ID: V02:K0:hqy7tZ4v5MnQ1dIPiC2fUw49oW1CygvK4AHPeAHeU53
 VdXRSFU2Te5UxejWByRvyZlsfBXIIHZpVm09Kq5Dy+pfADXa6u
 ARInBmfqSGu9LUai4VFsXhgZXPIsyic4SsOGvjtenN6Ku8OZQX
 tRnt/hEZUviIkV/ey5FUS4/8A7A01YhoXMa/XKDH9fRcixqD3n
 E4wtYwsgMYH6ext+8qfK2laWWnY7qKbsaVelncZagT4yEJSkZc
 EPUEdAxLNY7FFuDIGpix0H5cL/4KY84xsxaTYaezS26oY+gS33
 CuLH0HufHbSQu6FQqWXR038B0WlhFsYHh/s3HxuIdiqOdoi3EC
 RVx5tUUXrXy0CvL6pN9E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2012, Alessandro Rubini wrote:
> > Aside from the dma mask, this looks almost entirely generic. Would it
> > be possible to make this a generic pci-amba driver that lives under
> > drivers/amba/ and does not care about the type of device behind it?
> 
> Yes, it's possible. Actually, this was my longer-time plan: propose a
> factorization when more of those were ready.  So I'll remove the
> special name in the device and offer an implementation as generic
> as possible.
> 
> BTW, are the prerequisite patches of with you?
> 

Yes, they all look good to me, although patch 5 would have to change
if you do patch 6 the way we discussed here.

	Arnd
