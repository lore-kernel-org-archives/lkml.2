Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0LTQWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:22:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586Ab0LTQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:22:16 -0500
Date: Mon, 20 Dec 2010 11:22:01 -0500
From: Dave Jones <davej@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: flush_to_ldisc executing 2500 times a second ?
Message-ID: <20101220162200.GA2040@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
References: <20101201040709.GA28526@redhat.com>
 <20101220151124.GG1925@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220151124.GG1925@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:11:24PM +0100, Jiri Olsa wrote:
 > hi,
 > 
 > sorry for late reply, I just got back from vacation..
 > is this still an issue?
 > 
 > thanks,
 > jirka
 
I poked at it a while, then went to bed.
The next morning with the same kernel, I couldn't reproduce it.
Hasn't happened again since. Weird.

	Dave 
