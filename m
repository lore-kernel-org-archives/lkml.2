Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2IXRgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:36:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2IXRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:36:44 -0400
Date: Mon, 24 Sep 2012 10:36:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org, arekm@pld-linux.org, baggins@pld-linux.org
Subject: Re: [3.5.4] rcu_sched self-detected stall on CPU { 1}  (t=54862991
 jiffies)
Message-ID: <20120924173633.GA2451@kroah.com>
References: <1377033.GMb6SBRYYa@pawels>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377033.GMb6SBRYYa@pawels>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:05:23AM +0200, Paweł Sikora wrote:
> Hi,
> 
> with the new stable line i'm observing strange locks on my old amd-phenom-II mini-server.
> here's a dmesg:

Did this show up in 3.5.3?  If not, can you run 'git bisect' to find the
problem patch?

thanks,

greg k-h
