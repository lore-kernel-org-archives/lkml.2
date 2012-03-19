Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161738Ab2CSQOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:14:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46260 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161624Ab2CSQOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:14:18 -0400
Message-ID: <1332173657.1983.8.camel@joe2Laptop>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, David Miller <davem@davemloft.net>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Mar 2012 09:14:17 -0700
In-Reply-To: <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
References: <20120319040950.GG31682@thunk.org>
	 <20120319.001430.1735750114727679638.davem@davemloft.net>
	 <20120319043420.GL31682@thunk.org>
	 <20120319.011211.89954160788757412.davem@davemloft.net>
	 <20120319153133.GA2502@thunk.org>
	 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 17:51 +0200, Anca Emanuel wrote:
> Ted Ts'o: this effort is like BKL remove, ok, not like that.
> In 5 years, to have an standard. Mmm, maybe, less.

Probably about right, though I hope less than 5.
This stuff is tedious to get accepted and there
seems to be a maximum possible conversion rate.

> Joe, prease remind to all one more time your goal, and the benefits.

o standardize logging with subsystem/module id
o standardize debugging style (mask/level)
o standardize logging style to reduce future defects
o reduce current logging defects
o reduce code size (singleton for pr_fmt, deduplicate formats, %pV)
o remove most all #define pr_fmt


