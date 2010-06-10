Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0FJMo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:44:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34346 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab0FJMo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IxdcJGqr3ksfwCorvoeS7KUJPZOQmPK4I6/o39a3CSekVu0UTRfgMFagXbAoEvELbB
         gqnY+eZwbZ+zAypSRXeuKCAPKcjhCnSkLuOIGZoul9/ljIz82gFfbfIoL9+x2nElwkT6
         haCXsD9koahNttYS2NQz9xalVO7JWu88+OUU0=
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 18:14:25 +0530
Message-ID: <AANLkTimVgcnvb-obG4As0jjZQk6rwsHd-ByrfL4KxP0A@mail.gmail.com>
Subject: O_NONBLOCK with Ext2/3
From: "Yedire, Sandeep" <syedire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
What is the effect  on filesystem blocks,data blocks if O_NONBLOCK
flag is used with a test application doing write to a file(64MB) on
NAND Flash.
Can any one please let me know
Regards,
Sandeep.Yedire

----------------------------------------------------------
T.Jefferson, 'Victory and defeat are each of the same price"
