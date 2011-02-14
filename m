Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1BNBaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:30:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33676 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1BNBaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:30:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:cc:x-mailer;
        b=DU4h/EWn8O7B48JT0DuiMTjHma3v+7cSup8eYqLmOgYopjvr42kO9BACgxHMR/mpI/
         sa4AtFAuWg3TkZkPOjJg2SiPiUGQcj7kqjycvHWvWiQHEE6tLEH7g6aGF7ojSTrsiJxN
         zpjZBS0EvbDtIrQf8YAV9eFQJSkQ5yYXmK00c=
Message-Id: <1A8743E5-65EA-4625-82FD-658C9722629F@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: bluetooth disabled with current 2.6.38-rc4
Date: Sun, 13 Feb 2011 17:30:04 -0800
Cc: "linux-kernel@vger.kernel.org Mailing List" 
	<linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe I missed something, but my bluetooth is just not functioning with
2.6.38-rc4(works with 2.6.37-rc4)

I've done a bisect on this, but was pointed to:
c0e45c1ca3162acb2e77b3d9e152ce6e7b6fa3f5
but doesn't look correct to me

here is what I am seeing with the bluetooth-applet etc..:

working correctly:
http://www.flickr.com/photos/44066293@N08/5443727238/

not working:
http://www.flickr.com/photos/44066293@N08/5443124859/

my /var/log/daemon.log shows:

Feb 13 17:12:22 Linux-2 acpid: 1 client rule loaded
Feb 13 17:12:23 Linux-2 bluetoothd[1950]: HCI dev 0 registered
Feb 13 17:12:23 Linux-2 bluetoothd[1950]: Listening for HCI events on  
hci0
Feb 13 17:12:23 Linux-2 bluetoothd[1950]: HCI dev 0 up
Feb 13 17:12:23 Linux-2 bluetoothd[1950]: Unable to find matching  
adapter

I can try at another bisect, but might take some time.. let me know if  
there is something I can test
or do.

Justin P. Mattock
