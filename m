Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1ARQPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:15:32 -0500
Received: from antcom.de ([188.40.178.216]:53172 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1ARQPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:15:31 -0500
Message-ID: <4D35BCA1.1050002@antcom.de>
Date: Tue, 18 Jan 2011 17:15:29 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101110 Iceowl/1.0b2 Icedove/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: GPIO: Handling multiple lines at once
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in the standard gpio interface (see Documentation/gpio.txt), we have an
interface to manipulate single GPIO lines.

Several drivers are implementing an interface for devices that can
handle multiple lines at once. E.g. Maxim MAX7301
(drivers/gpio/max7301.c). There, you can get/set/configure 8 bits at
once which is really helpful if you are handling 8 bit data as
bytes/characters via the lines.

Is there an appropriate interface for this case that I'm somehow missing
from the docs and the code?

Or do I need to create it myself?

Or is this a use case not considered "GPIO" at all?

Please CC me.

Thanks in advance!

Roland
