Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1IELwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55356 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1IELr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110905091540.GA22014@infradead.org>
References: <4E5B4AAF.2040101@samsung.com>
	<CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
	<4E5B65C6.6070300@samsung.com>
	<CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
	<CAF1ivSZxAuVaivJyoZ=gnMu-YY7AcnBwCWtD74DqPuYAASxTxA@mail.gmail.com>
	<CAH9JG2W+wEfpL6baQmvigcH9LRn6p0wTszK+urPKxpNfHsjUCQ@mail.gmail.com>
	<20110905091540.GA22014@infradead.org>
Date: Mon, 5 Sep 2011 20:47:58 +0900
X-Google-Sender-Auth: ao10f6k6sFe3lT_4KDpJEswr4Hk
Message-ID: <CAH9JG2UevPYDOFycLGbh+zu9CyoDx8N8qnCzMy0Lq2b+06EatA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Kyungmin Park <kmpark@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Lin Ming <lxy@ss.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Sep 5, 2011 at 6:15 PM, Christoph Hellwig <hch@infradead.org> wrote:
> So what the heck is a tunable request supposed to be?  How does it
> qualify for beeing a generic request/bio type?

The concept is similar with DISCARD request except no-wait for request complete

 #define REQ_DISCARD            (1 << __REQ_DISCARD)
+#define REQ_TUNE               (1 << __REQ_TUNE)

As it's hard to detect the idle time at device level, user send the
tune request to device when idle.

Thank you,
Kyungmin Park
