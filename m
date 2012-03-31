Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab2CaSVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:21:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38551 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2CaSVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120331033306.GA2475@burratino>
References: <20120316233829.GA14022@kroah.com> <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways> <20120331033306.GA2475@burratino>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 11:20:41 -0700
X-Google-Sender-Auth: Mb--RMoIRMxBBtXAo-ZR1G0I7qo
Message-ID: <CA+55aFy2WdyeBc0j77UAjisThrm2ZDbC7O1O05kiOeBeiP1KZQ@mail.gmail.com>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 8:33 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>
> You might enjoy the following patch:
>
>  http://thread.gmane.org/gmane.linux.kernel.pci/14503

Yes, good. I guess I should just take it and not wait for Bjorn, since
we really need this for stable too. Matthew?

                Linus
