Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0L3RN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:13:56 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:58852 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0L3RNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:13:55 -0500
X-Greylist: delayed 3186 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 12:13:55 EST
Message-ID: <4D1CB15E.6020507@xs4all.nl>
Date: Thu, 30 Dec 2010 17:20:46 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: GPIO on VIA Epia
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Did anyone do some work on a driver to use the GPIO pins on the VIA Epia
boards based around the vt8237 or CX700?
E.g. my Epia LT offers 8 programamble GPIO pins according to the
documentation (see below for layout) but I'd like to know if there is a
driver so I can actually use them and e.g. receive an interrupt when a
GPIO goes high or low.
Please let us know what is available.

Thanks,
Udo


Epia LT documentation:

Digital I/O Connector: DIO
General purpose input and output for POS systems.

 Pin     Signal               Pin     Signal
 1       5V_DIO               2       12V_DIO
 3       GPO_21               4       GPI_44
 5       GPO_22               6       GPI_45
 7       GPO_32               8       GPI_46
 9       GPO_33               10      GPI_47
 11      GND                  12      GND
