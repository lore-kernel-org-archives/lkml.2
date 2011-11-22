Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1KVOko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:40:44 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:47366 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755641Ab1KVOkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:40:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KURt3QoVM1mGahqifantOUXddtjnovBxHrAAJXI2LoeBeEf
 beCjOfUWimZKof6UwHxqw.Eal8pc5wdxKgGIOzvR1WumK4ZCzV82ps7g.0gA
 KwuaXzCjOL3gL3VZKfz.sO1.uPe6AGx_Ts5.8h6qNXrAoipWYHexP6mwqrEo
 M5eHm9PqEdhS9FesPQGMdm84emu.CI0yPAz5y5zTGsThoUG2LCnoibwo_17N
 QPWRRcbDrV6bw_Oeyp2oalDnQQ2FpSbfwPSNw5LY2hdDrf_z26l.4D.e7RaB
 QFdZnBeUB3ptHxkWIHjDe8aP2UpBY8bVtL9Vf1SAfSCq6x2iAlv5ISlU7lMB
 26Lcap7GwugM3RyvwGbk3A1Amv3RSSs1LfWwXD5IFHjKPe.nY_hFf8M17SOu
 W4gNYTDVDU3EdlIVhYXZH6m4r0eTzmHTKXwTK
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 08:40:41 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slub_max_order Documentation
In-Reply-To: <1321941549.27077.17.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1111220840260.25785@router.home>
References: <1321941549.27077.17.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> slub_max_order default is 3 (aka PAGE_ALLOC_COSTLY_ORDER), not 1

Acked-by: Christoph Lameter <cl@linux.com>
