Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2AMPZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:25:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37106 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab2AMPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:25:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120113144113.GA25667@elgon.mountain>
References: <20120113144113.GA25667@elgon.mountain>
Date: Fri, 13 Jan 2012 17:25:50 +0200
Message-ID: <CAJL_dMvBycLdpbvOowcLjcjM3CZp=j+i6_mvLzZiTTGONuD_pA@mail.gmail.com>
Subject: Re: [patch -next] autofs4: double lock typo in autofs4_write()
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is already reported:
https://lkml.org/lkml/2012/1/13/104

and tested by Dave.
