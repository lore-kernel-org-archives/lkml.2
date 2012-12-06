Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2LFFSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 00:18:49 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34235 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2LFFSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 00:18:48 -0500
MIME-Version: 1.0
In-Reply-To: <20121205184316.GA18227@elgon.mountain>
References: <20121205184316.GA18227@elgon.mountain>
Date: Thu, 6 Dec 2012 06:18:46 +0100
Message-ID: <CAJSP0QU91tbs1NciKJtExszbuEjUhLR_nY--1+6aKkZmKoCO+w@mail.gmail.com>
Subject: Re: [patch 1/2] staging: line6: delete an unused function
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Johannes Thumshirn <morbidrsa@googlemail.com>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 7:43 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> line6_send_sysex_message_async() isn't called from anywhere.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
