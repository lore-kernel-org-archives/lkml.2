Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab1EMQqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:46:05 -0400
Received: from mailx.techworks.ie ([88.198.36.49]:50575 "EHLO
	mailx.techworks.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198Ab1EMQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:46:03 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 12:46:02 EDT
Message-ID: <4DCD5E53.4080505@techworks.ie>
Date: Fri, 13 May 2011 17:37:39 +0100
From: Christian Gagneraud <chris@techworks.ie>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: AT91: SPI: On implementing peripheral chip select decoding
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

The AT91SAM9G20 SPI controller (and possibly other SAM9 or other SoC) 
has the ability to work with CS decoding, thus allowing up to 15 
peripherals with only 4 CS lines (CS[0:3]=0xF meaning no peripheral 
selected).
I would like to know if anyone has experimented with this feature, or if 
anyone has advices/ideas on how to add support for this feature in the 
linux kernel.

Before starting to work on this, I would like to know if this feature is 
common on other platforms or if it's AT91 specific.
In the former case, it might be wise to include it in the SPI subsystem, 
and in the latter case keep it inside AT91 code.

Chris

