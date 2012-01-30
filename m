Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2A3Obj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:31:39 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40069 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167Ab2A3Obi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:31:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120127191532.GA25529@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
	<CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
	<20120127105859.GC23335@infradead.org>
	<CAAA8XhOoF_AN_-1PsYQ+hp7adc08YuYqvA_3Bv9nqtuOzO1kOg@mail.gmail.com>
	<20120127191532.GA25529@infradead.org>
Date: Mon, 30 Jan 2012 12:31:36 -0200
Message-ID: <CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
Subject: Re: XFS problem
From: Kelbel Junior <jymmyjr@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Christoph.

Yes, we work on 1TB file, doing lots of random I/O over a single file.
We are using 'pwrite' ofr each write operation.

Output of 'filefrag' in this file:
file: 1364 extents found

The 'mount' options are the same as mentioned earlier.
About RAID, we use RAID 0.

In a file with this size and this extents amount could happen the
problem that we're seeing?


Thanks.
Kelbel Junior
