Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2B1Rwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:52:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab2B1Rwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:52:49 -0500
Message-ID: <4F4D13DB.1040205@zytor.com>
Date: Tue, 28 Feb 2012 09:50:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Davidlohr Bueso <dave@gnu.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 6/6] USB: ffs-test: Don't duplicate {get,put}_unaligned*()
 functions
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org> <1330436245-24875-7-git-send-email-matt@console-pimps.org>
In-Reply-To: <1330436245-24875-7-git-send-email-matt@console-pimps.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 05:37 AM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Use the header file in tools/include instead of duplicating the endian
> functions.
> 
> Cc: Davidlohr Bueso <dave@gnu.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Greg and Dave, since the rest of this series is all in the x86
directory, mind if I pick it up and put it in the -tip tree including
this patch?

	-hpa

