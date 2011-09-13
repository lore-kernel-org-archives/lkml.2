Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1IMHeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:34:25 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:62282 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1IMHeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:34:24 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 03:34:24 EDT
MIME-Version: 1.0
In-Reply-To: <CAKaWdxbcpZKL9pkf0sKS3OarSE-jRgy8QKuGu=0NEd3Rigq0dg@mail.gmail.com>
References: <CAKaWdxbcpZKL9pkf0sKS3OarSE-jRgy8QKuGu=0NEd3Rigq0dg@mail.gmail.com>
Date: Tue, 13 Sep 2011 19:26:58 +1200
Message-ID: <CAKaWdxaWs-sY_Tw4fKPwSLUh3NY=RmQdZgBSyX-JA8J5OR=Eaw@mail.gmail.com>
Subject: Re: IRQ Storm - nobody cared
From: Keith Chew <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 7:11 PM, Keith Chew <keith.chew@gmail.com> wrote:
<snip>
> I have analysed the dmesg, and I cannot pin point the culprit.  But if
> I pull out the PCI video capture card, then the system behaves well.
> So, perhaps this is a BUG in the bttv driver with ICH9 chipset?
>
> Regards
> Keith
>

Please disregard this email, we got a new BIOS, and the problem is solved!

Regards
Keith
