Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1G0OGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1G0OGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:06:12 -0400
Date: Wed, 27 Jul 2011 10:05:24 -0400
From: Dave Jones <davej@redhat.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110727140523.GA24206@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20110727135730.GA17717@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727135730.GA17717@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 08:57:31AM -0500, Jack Steiner wrote:

 > Note: patch assumes that all multi-core x86 processor sockets have the same
 > clock frequency for all cores. AFAIK, this is true & will continue
 > to be true for a long time. 

not necessarily true. (the 'long time' part might be sooner than you think)

	Dave

