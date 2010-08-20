Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0HTUeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:34:14 -0400
Received: from legolas.restena.lu ([158.64.1.34]:53402 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0HTUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:34:12 -0400
Date: Fri, 20 Aug 2010 22:33:16 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.36 regression] Under linux console gpm cursor now going to
 opposite direction of mouse
Message-ID: <20100820223316.4f6ac734@neptune.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between 2.6.35 and Linus's tree as of this writing gpm
started moving its cursor to the opposite direction of mouse movement.

e.g. moving mouse up causes cursor to move down, moving mouse left
     causes cursor to go right

Under 2.6.35 the cursor moved into the same direction as the mouse.

Note, mouse is synaptics touchpad (Acer TravelMate660):
  Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006/0x0


When I get around to it I will try to get more precise information as
to when this regression got introduced, eventually bisecting.

Bruno
