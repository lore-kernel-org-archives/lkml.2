Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0FILas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:30:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46541 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0FILaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xYJ1QnKPk3tCB0Pi1pAzTAphQWhK1AUjZuPIekD3LKSShNkYlr3eOAS6mmAqODjFYi
         OvRev0I8bnJM9YccNeu8Qn3g0xGQxczkEw5R5yFJoVeuKDo4yG4eivZ/ubURt7hApiJP
         tnAUPdKB98KvGFB5P5Ds82OcS56UPxN90yOGA=
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 17:00:45 +0530
Message-ID: <AANLkTilXU8paNWNUSQIjcQ7xaaWgB1bEyd70d5P_nWf2@mail.gmail.com>
Subject: O_NONBLOCK with Ext3
From: "Yedire, Sandeep" <syedire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ALL,
I am currently using o_nonblock flag for writing a file of 64MB over a
flash device. Flash is formatted with ext3 filesystem with default
options.
When instrumented the driver code for collecting the erase/write count
at sector level. I noticed that o_nonblock has no effect on this
count. There is no difference in erase/write count with o_nonblock
flag or without this flag.
When selected Ext2 as filesystem I noticed a significant difference in
the erase/write count.
There were more updates with o_nonblock and test application was
faster. I could confirm this by checking the Dirty page limit in the
background. It was updating faster in case of Ext2 not incase of Ext3.

Can any one explain on o_nonblock flag in case of  Ext3 filesystem?

Regards,
Sandeep.Yedire

----------------------------------------------------------
T.Jefferson, 'Victory and defeat are each of the same price"
