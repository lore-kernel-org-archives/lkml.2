Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2DJGyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:54:51 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50770 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2DJGyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:54:50 -0400
X-Greylist: delayed 3556 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 02:54:49 EDT
Message-ID: <20120410075532.16392krd825c0ris@mail.tu-chemnitz.de>
Date: Tue, 10 Apr 2012 07:55:32 +0200
From: Markus Franke <markus.franke@informatik.tu-chemnitz.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de>
 <20120409220847.GA13124@kroah.com>
In-Reply-To: <20120409220847.GA13124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.9)
X-Originating-IP: 217.7.19.178
X-Scan-AV: mailbox.hrz.tu-chemnitz.de;2012-04-10 07:55:32;bca90d146c4d8f6be3a0ea50e0eb07dd
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-04-10 07:55:32;442aa8451c8072219a5ed1182d54884f
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -0.0 T_RP_MATCHES_RCVD Envelope sender domain matches handover relay
 *      domain
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

Zitat von Greg KH <gregkh@linuxfoundation.org>:

> On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke wrote:
>> This patch adds a 1-wire slave device driver for the DS28E04-100.
>>
>> It applies to the current linux kernel git tree.
>
> It's corrupted somehow and doesn't apply at all :(
>
> Care to redo this one, and your 2/2 patch, against the 3.4-rc2 release
> and resend it, with Evgeniy's acks, so that I can apply it?  Please
> ensure that your email client doesn't mess it up again (hint, it is
> adding spaces at the front of the line of some parts of the diff.)

I don't have a clue what might go wrong within my email client. Would  
sending it as an attachement be an option? If not I might have to  
switch to another client.

Best regards,
Markus Franke


