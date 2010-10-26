Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0JZBTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:19:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53579 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518Ab0JZBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:19:49 -0400
Date: Mon, 25 Oct 2010 18:19:55 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2 v2] regulator: max8952 - fix max8952_set_voltage
Message-ID: <20101026011955.GA3432@opensource.wolfsonmicro.com>
References: <1288050954.2323.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288050954.2323.3.camel@phoenix>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 07:55:54AM +0800, Axel Lin wrote:
> In current implementation, vid is declared as u8,
> then "vid == -1" is always false, and "vid >= 0" is always true.
> Thus change it to s8.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
