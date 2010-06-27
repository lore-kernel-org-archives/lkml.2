Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0F0HGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 03:06:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35873 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab0F0HGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 03:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <352874.17151.qm@web180303.mail.gq1.yahoo.com>
References: <1276778870-1065-1-git-send-email-dbaryshkov@gmail.com> 
	<352874.17151.qm@web180303.mail.gq1.yahoo.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 27 Jun 2010 01:05:44 -0600
X-Google-Sender-Auth: kfGIR-9aih5BpXccSmq7jxR8GC4
Message-ID: <AANLkTilIZ2X3-b53tpr8zKG0Qn-9Shgt4urMOpQg2xSU@mail.gmail.com>
Subject: Re: [PATCH] pcf857x: support working w/o platform data
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 4:17 AM, David Brownell <david-b@pacbell.net> wrote:
>
>
> --- On Thu, 6/17/10, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>
>> Provide sane defaults for pcf857x, so
>> the driver can be used w/o
>> providing platform data (and thus can be simply bound via OF tree).
>
>
> Maybe we can get an ack from some OF folk
> who are using it in that way?

I'm not actually using this chip, but the change looks sane to me.

g.
