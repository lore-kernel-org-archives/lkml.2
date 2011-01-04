Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1ADROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:14:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1ADROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:14:19 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Network Virtual Terminal
Date: Tue, 4 Jan 2011 18:13:46 +0100
User-Agent: KMail/1.9.10
Cc: Rodolfo Giometti <giometti@linux.it>, Russell Coker <russell@coker.com.au>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1294067735-21466-1-git-send-email-giometti@linux.it>
In-Reply-To: <1294067735-21466-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101041813.49759.hpj@urpla.net>
X-Provags-ID: V02:K0:MD9pO0QtY718g9H+Ywi5GSGvyCaFtpfgv1JHpYgaRtg
 cwN6aX8RWDQE7jOC4rrpIDA1mvpkVUlVrkMebD5fBW3LjrNNOO
 7AljHIkpOhL+In5gQ5Fpr8AGhfZwP57aXJNxaA0b7tW2L/Fa0q
 N8vU+c1xhHGWCUzAcpzrmjGNQbyKfcgRx+8Sg8ayiOvxmcrpdu
 nCQh+rCAZT36QCktrSvjVU44vXnLAsSPmbz2+Fmbew=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rodolfo,

On Monday 03 January 2011, 16:15:34 Rodolfo Giometti wrote:
> Hello,
>
> here my implementation of Network Virtual terminals (NVT tty)
> according to RFC 854 and RFC 2217... actually this is the client side
> part since as remote server I used sredird
> (http://freshmeat.net/projects/sredird/).

Sounds interesting. Could you outline the limits a bit? In one of my use 
cases, I need to support 1200 baud with a rather esoteric 7E2 serial 
setup. (Needless to say, the client is a butt ugly win app to control 
gasoline pumps, running inself in a VMware WS setup. I'm supporting 
this since ten years now, where VMware took about 4 years to get the 
serial setup right finally...) Being able to redirect the serial data 
over network (in an inexpensive, but reliable way) would make my life 
significant easier in this respect.

Pete
