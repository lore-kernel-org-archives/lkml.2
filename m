Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2LFJeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:34:08 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58107 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2LFJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:34:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAJSP0QU91tbs1NciKJtExszbuEjUhLR_nY--1+6aKkZmKoCO+w@mail.gmail.com>
References: <20121205184316.GA18227@elgon.mountain>
	<CAJSP0QU91tbs1NciKJtExszbuEjUhLR_nY--1+6aKkZmKoCO+w@mail.gmail.com>
Date: Thu, 6 Dec 2012 10:34:02 +0100
Message-ID: <CAGH8bx5U3zTm1LFmQY1zQc33mVczBkQvnqHb-Cs5A6c93y1H6g@mail.gmail.com>
Subject: Re: [patch 1/2] staging: line6: delete an unused function
From: johannes thumshirn <morbidrsa@gmail.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Johannes Thumshirn <morbidrsa@googlemail.com>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 6:18 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Wed, Dec 5, 2012 at 7:43 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> line6_send_sysex_message_async() isn't called from anywhere.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>

Reviewed-by: Johannes Thumshirn <morbidrsa@googlemail.com>
