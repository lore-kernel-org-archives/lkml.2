Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0G2PT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:19:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33854 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0G2PT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ouWGUvP6FYm/eDR5VGT2TJV0rba8gDD+3iNxCybE91t70JpZ6uQ+10KLvR8Und7KJy
         CkpIdI+g5qPu9WAH/nNQfLkW4hCChdyK9ENj+BKGi98gNwtVnNtoLjjbFjvr/dM6f1AA
         0K0utewFsotcO7D6H0gkhIQvdLqBDNL22hdKk=
MIME-Version: 1.0
Date: Thu, 29 Jul 2010 20:49:26 +0530
Message-ID: <AANLkTikk_qRbE7oEV6yLXD9=hPbLEo0WO0dE26h2fc5A@mail.gmail.com>
Subject: Controlling the network bandwidth to adapt the throughput
From: Madhavi Manchala <madhavi.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I want to write a small application which is used to CONTROL the
network bandwidth that passes through my Red Hat Linux system i.e. my
server (software) will need to adapt the throughput. I know, there are
lot of existing tools like TRICKLE, WANEM, TC (HTB), Little Snitch
etc. which are used for monitoring and control of the network traffic
(mainly shaping of the netwrok bandwidth).

What would be a good starting point? Please suggest.

Regards,
Madhavi.
