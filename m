Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1KBGbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:31:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42807 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1KBGbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:31:31 -0400
Date: Wed, 2 Nov 2011 14:31:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Frank =?utf-8?Q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on device removal when using a workqueue and
 delayed_work
Message-ID: <20111102063119.GA7387@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4EADA32E.6030200@googlemail.com>
 <20111031031136.GA18057@zhy>
 <4EAE77F2.80102@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EAE77F2.80102@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 11:26:58AM +0100, Frank Schäfer wrote:
> Am 31.10.2011 04:11, schrieb Yong Zhang:
> That's what I'm doing (see above).
> Did you read the code ? ;-)

Oh, blind me.

Maybe you can enable DEBUG_OBJECTS_TIMERS && DEBUG_OBJECTS_WORK
to check if anything is broken.

Thanks,
Yong
