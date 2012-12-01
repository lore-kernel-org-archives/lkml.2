Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2LAXDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:03:36 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:50954 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2LAXDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:03:35 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: Re: Likely mem leak in 3.7
In-Reply-To: <m31ufrg3d4.fsf@carbon.jhcloos.org> (James Cloos's message of
	"Sat, 17 Nov 2012 19:29:18 -0500")
References: <m3r4nuwipl.fsf@carbon.jhcloos.org>
	<alpine.DEB.2.00.1211161115001.2788@chino.kir.corp.google.com>
	<m31ufrg3d4.fsf@carbon.jhcloos.org>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.3.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEX///8ZGXBQKKnCrDQ3
 AAAAJElEQVQImWNgQAAXzwQg4SKASgAlXIEEiwsSIYBEcLaAtMEAADJnB+kKcKioAAAAAElFTkSu
 QmCC
Copyright: Copyright 2012 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 01 Dec 2012 17:48:28 -0500
Message-ID: <m38v9he6cq.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Hashcash: 1:30:121201:linux-kernel@vger.kernel.org::1tYhJI4RYtnIpr5E:00000000000000000000000000000000ndolq
X-Hashcash: 1:30:121201:linux-btrfs@vger.kernel.org::ZtSXy709APFo5JgF:000000000000000000000000000000000sbVML
X-Hashcash: 1:30:121201:rientjes@google.com::Lq0kLJ0bbQBGsvDk:00000000000000000000000000000000000000000YZcWW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've extensively tested 2844a48706e5 (tip at the time I compiled) for
the last few days and have been unable to reproduce.

This bug appears to be fixed.

Thanks.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
