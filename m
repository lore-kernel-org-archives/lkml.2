Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0JSSbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:31:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1739 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0JSSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:31:24 -0400
Date: Tue, 19 Oct 2010 20:31:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101019203101.197d493d@endymion.delvare>
In-Reply-To: <20101019180805.GA31594@ericsson.com>
References: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
	<20101019190647.314302e7@endymion.delvare>
	<20101019180805.GA31594@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 11:08:05 -0700, Guenter Roeck wrote:
> On Tue, Oct 19, 2010 at 01:06:47PM -0400, Jean Delvare wrote:
> > On Tue, 12 Oct 2010 18:15:16 -0700, Guenter Roeck wrote:
> > > +     if (data->virt_adap == NULL) {
> > > +             dev_err(&client->dev,
> > > +                     "failed to register master selector as bus %d\n",
> > > +                     force);
> > 
> > This error message is somewhat confusing if "force" is 0: in that case
> > you didn't request any specific bus number.
>
> This is from pca954x code. Not sure how to rephrase it. Got an idea ?

Just "failed to register master selector\n" should do. The adapter
number doesn't really add any value.

-- 
Jean Delvare
