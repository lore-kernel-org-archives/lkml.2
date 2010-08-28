Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0H1L1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:27:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35265 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0H1L1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eeV71g9FrDKSuLU+x73UofCi8L7RW7vEwk1U5YUIfX4K2Kap1x7QaO6ejPBKio/HLY
         sSotOGbb0KIisH9enW3JO9YzGJ1DRlY42zRaPzK3LhPmAg6RFOr1baOG19VJpxDBU0GA
         kZ5sJabapVVJ6O4MMIGf7oxKN8FbcNd8RqntU=
MIME-Version: 1.0
Date: Sat, 28 Aug 2010 16:57:31 +0530
Message-ID: <AANLkTinYuck4yEGpFDKZp-R3N2dtoQ68cLHQY6EW6sr-@mail.gmail.com>
Subject: [Question] How to test (DRAM) memory location.
From: santosh <santosh.iitg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to write a memory diagnosis  program which will test each and
every location of SDRAM
to know whether its working properly or a bad location

What would be the best approach ??

If I want to test each location sequentially then How can I do it ? If
Base address is required then how to find it in my system??

regards
Santosh
