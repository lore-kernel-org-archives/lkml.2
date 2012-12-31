Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2LaLSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:18:50 -0500
Received: from grace.univie.ac.at ([131.130.3.115]:58786 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2LaLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:18:47 -0500
Message-ID: <7f906dcd4ecf9dc0d47084c7b93950d3.squirrel@webmail.univie.ac.at>
Date: Mon, 31 Dec 2012 12:18:45 +0100
Subject: what's the return-value of regulator_get?
From: "Piotr Sawuk" <a9702387@unet.univie.ac.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Univie-Virus-Scan: scanned by ClamAV on justin.univie.ac.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I repeat my question:
the driver for lsm303dlh in the 3.5 kernel calls regulator_get(&client->dev,
"vdd");
from that it got the return-value fffffdfb triggering IS_ERR().
but I cannot find any errorcode for -0x205.
does anyone know the meaning of this error-code?

P

