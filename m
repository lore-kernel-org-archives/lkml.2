Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1KVPDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:03:41 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:35911 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753364Ab1KVPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:03:40 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: m95z8bsVM1mJsSooaLqkxKhbnVWr.UcReFoDgapectn7QjI
 qFeVwR0mXOCCzjBoI19gf9ttBpmUu8FLqRLQuFEtHAboyLtl526e9C8eg42S
 MB9c3rwNSlzdeNxH5EIB4LA.nI0sJvtLFekPfe.Y.44ZctutEGOYFBSr5v_D
 1wBws2jGsuvT5Hb0PajgBzrUalLWakr9sxzVTt19hsEJXh_LS9uE4Ves0NZX
 tqLrCtrdkq6eNOwEjhT27Nt2V87AXiVosvU_fBVNqUUxdVXnPIph.oTF7Ow7
 kcQWqz9ZkchnssdzQ6i2YMX6yIDIvrxd507.O2FA3QS9Mtd5I9TMegArxLuH
 dcvuL30f7fT5Loy1Jy233NNS2BUS7RUyQ.gZmwHJBFYyn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 09:03:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220903250.25785@router.home>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> show_slab_objects() can trigger NULL dereferences or memory corruption.

Acked-by: Christoph Lameter <cl@linux.com>

