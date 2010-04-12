Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0DLGsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:48:30 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59094 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab0DLGs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:48:29 -0400
X-Sasl-enc: TByE5XqYEpUjAgGzZRfSp7SqoQUBV4uiLwBK/rxLY6M1 1271054907
Message-ID: <4BC2C23A.9060506@ladisch.de>
Date: Mon, 12 Apr 2010 08:48:26 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jay Fenlason <fenlason@redhat.com>, David Moore <david.moore@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: cdev: change license of exported header files
 to MIT license
References: <20100405192651.GA20312@redhat.com> <x2ma7f4d8771004052207m50ca8695ud34432ebbc84bcab@mail.gmail.com> <z2g59ad55d31004081307w2211434as3a3889a256f3ce4@mail.gmail.com> <tkrat.447a38c0ad4dc6d9@s5r6.in-berlin.de>
In-Reply-To: <tkrat.447a38c0ad4dc6d9@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Among else, this allows projects like libdc1394 to carry copies of the
> ABI related header files without them or distributors having to worry
> about effects on the project's overall license terms.  Switch to MIT
> license as suggested by Kristian.  Also update the year in the
> copyright statement according to source history.
> 
> Cc: Kristian Høgsberg <krh@bitplanet.net>
> Cc: Jay Fenlason <fenlason@redhat.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
