Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1LETkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:40:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51073 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269Ab1LETkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:40:11 -0500
Date: Mon, 5 Dec 2011 19:40:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl
 for reading registers
Message-ID: <20111205194006.GG7467@opensource.wolfsonmicro.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <20111125220448.GA2078@oksana.dev.rtsoft.ru>
 <20111127115416.GA2579@sirena.org.uk>
 <5110851.ffWC54aKVq@pali-elitebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5110851.ffWC54aKVq@pali-elitebook>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 08:37:23PM +0100, Pali Rohár wrote:

> I do not know regmap api, but I need interface which is easy readable from C 
> or shell scripts and which can read some registers (numbers 0-N).

The regmap debug file is a file of lines in the format 'regnum: value'
where both fields have a fixed width so should be easily parsable.
