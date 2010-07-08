Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0GHKE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:04:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46764 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0GHKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kuOswJ5H6s7rvUqsdIRJOUeBOxDH4iI6zkhXeIzKUAJ7VHn5tbhV+174dS0ysHiRB6
         GqMpOmLFD4IBKxD0KXD64DQroRIS+WwmNX4KX1SKsG+tgW4r1vOCNh1mOwV+l+m18/by
         PrRuwVH1gZBV3KWLn+CkeEMwzVOuWKMjHjUr0=
MIME-Version: 1.0
Date: Thu, 8 Jul 2010 15:34:56 +0530
Message-ID: <AANLkTimFHZt-lC6XxYdzRqwe3wRxQkjzAanMeR0MsZ6J@mail.gmail.com>
Subject: SD Driver : FAT: FAT read failed (blocknr 8) in sd card error while 
	removing sd card during writing
From: hardik patel <hk5patel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have sd card on board ... During recording/writing SD card, remove
SD card ... then i am getting endless error in dmesg as below :

end_request: I/O error, dev mmcblk0, sector 24
FAT: FAT read failed (blocknr 8)
mmcblk0: error -110 sending status comand<3>mmcblk0: error -110
sending read/write command, response 0x0, card status 0x0
Block mmc_blk_issue_rq function call 346
end_request: I/O error, dev mmcblk0, sector 4
FAT: FAT read failed (blocknr 4)
MMC: killing requests for dead queue
end_request: I/O error, dev mmcblk0, sector 8
FAT: FAT read failed (blocknr 8)
FAT: FAT read failed (blocknr 4)
FAT: FAT read failed (blocknr 8)
FAT: FAT read failed (blocknr 4)
FAT: FAT read failed (blocknr 8)
FAT: FAT read failed (blocknr 4)
FAT: FAT read failed (blocknr 8)

How to stop this message ... what is ideal situation when we remove
card while writing ...... can u help me what to do ?

where is the problem here? sd host controler driver problem or block
driver problem or file system problem

Note: I have formatted sd card with FAT32 file system .



With EXT3 File system :

Remove SD card while writing/recording we got error messages like
below. but this is not endless. After some time it stops.

end_request: I/O error, dev mmcblk0, sector 156536
mmcblk0: error -110 sending status comand<3>mmcblk0: error -110
sending read/write command, response 0x0, card status 0x0
mmcblk0: error -110 requesting status
end_request: I/O error, dev mmcblk0, sector 4736
Aborting journal on device mmcblk0p1.
ext3_abort called.
EXT3-fs error (device mmcblk0p1): ext3_journal_start_sb: Detected
aborted journal
Remounting filesystem read-only
end_request: I/O error, dev mmcblk0, sector 4448
journal commit I/O error
