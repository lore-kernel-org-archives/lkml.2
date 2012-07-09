Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2GIJVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:21:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47527 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2GIJVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:21:23 -0400
Subject: Re: 82571EB: Detected Hardware Unit Hang
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: e1000-devel@lists.sf.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4FFA9B96.6040901@oracle.com>
References: <4FFA9B96.6040901@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jul 2012 11:21:17 +0200
Message-ID: <1341825677.3265.2330.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 16:51 +0800, Joe Jin wrote:
> Hi list,
> 
> I'm seeing a Unit Hang even with the latest e1000e driver 2.0.0 when doing
> scp test. this issue is easy do reproduced on SUN FIRE X2270 M2, just copy
> a big file (>500M) from another server will hit it at once. 
> 
> Would you please help on this?
> 

Its a known problem.

But apparently Intel guys are not very responsive, as they have another
patch than the following :

http://permalink.gmane.org/gmane.linux.network/232669


We only have to wait they push their alternative patch, eventually.

In the mean time, you can use Hiroaki SHIMODA patch, it works.



