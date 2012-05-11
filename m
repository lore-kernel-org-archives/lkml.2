Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab2EKPrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:47:04 -0400
Received: from mta1.math.wisc.edu ([144.92.166.194]:34260 "EHLO
	mta1.math.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262Ab2EKPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:47:03 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2012 11:47:02 EDT
Message-ID: <E0BBA37A8B0840BF82FE8AEADEBE8B5D@math.wisc.edu>
From: "John Heim" <jheim@math.wisc.edu>
To: <linux-kernel@vger.kernel.org>
Subject: patch for speakup serial hardware synths
Date: Fri, 11 May 2012 10:36:54 -0500
Organization: University of Wisconsin-Madison
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few weeks ago I asked about a problem with the speakup screen reader code. 
It does not work with serial hardware speech synthesizers. But I managed to 
get it working. How can I submit my fix for integration into the kernel 
code. The patch file can be downloaded here:
http://www.math.wisc.edu/~jheim/downloads/patch-2012-03-06.patch

To install it you cd to the linux source directory and do this:
patch -i patch-2012-03-06.patch drivers/staging/speakup/serialio.c"


