Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2ICIpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:45:41 -0400
Received: from mail.dce.bg ([46.40.123.75]:65078 "HELO mail.bulcrypt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754695Ab2ICIpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:45:40 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2012 04:45:40 EDT
Message-ID: <50446CA1.7040904@dce.bg>
Date: Mon, 03 Sep 2012 11:38:57 +0300
From: Alexander <alexander@dce.bg>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: file Documentation/usb/usbmon.txt should list the .config settings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please indicate in the Documentation/usb/usbmon.txt file that the kernel 
needs to be compiled with:

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_FS=y
CONFIG_USB_MON=y
CONFIG_USB_DEVICEFS=y

, in order for usbmon to be useable on the system.

