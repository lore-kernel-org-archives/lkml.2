Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0IGBj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:39:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57920
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab0IGBjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:39:25 -0400
Date: Mon, 06 Sep 2010 18:39:42 -0700 (PDT)
Message-Id: <20100906.183942.52176647.davem@davemloft.net>
To: qy03fugy@stud.informatik.uni-erlangen.de
Cc: rolandd@cisco.com, adobriyan@gmail.com, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 06/14] drivers/net: Removing undead ifdef CHELSIO_T1_1G
From: David Miller <davem@davemloft.net>
In-Reply-To: <fd089f3e72b01fc29faf8113606354f6c423f141.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<fd089f3e72b01fc29faf8113606354f6c423f141.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Date: Mon, 6 Sep 2010 16:36:25 +0200

> The CHELSIO_T1_1G ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Applied.
