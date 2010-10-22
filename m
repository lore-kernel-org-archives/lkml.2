Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0JVVwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:52:43 -0400
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:33408 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752313Ab0JVVwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:52:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hH0GlHFG94PLzXORWvxiqx1L0XKGZwPZXFW5+iOxGcFyBT6ZKex3gHktlyGeSCjl3etk6BIhT8wAE3kFLDNYyFY12VUehjDxlee2LzSTKWwHx53MgDD/YW9JKoOmcZueh3MaNlaoPGzDh+VLWNgR1gPaKmqLjBaW4wM0KbOc1y8=;
Message-ID: <927255.77335.qm@web31804.mail.mud.yahoo.com>
X-YMail-OSG: bq.AGzgVM1nGkUBG6eu_65_oi1vJ0M7Et6_lIOMbrU23g1H
 G9gNB.C2SdXkYWCjx0wdApS100Td40R4rdZ7XONDSukhdI53IPfzjYH.dMzo
 0IHDvKeEgYEwq4SLY6cxwSLSD3_QKaaKhrO7JJmLnzl4ge8s_qEOxjk_OCXu
 q0NbjIo8VrBqxE8oUB.ygbWcQGAgl93KI9VVp3N.rU5EJhu7vorN9aqI.67N
 fBgj9scllMj3QZ3lI7hVOC4M1nV57Q4YtfKE8h7xOjbtiSn5STbcqECe2H13
 ZcdpVX3Aumc36K2koCHyqBPlpc2ibuEkmgnVf_bTSCcfmn2ImISwxxls81kc
 HFAoSzKUGuHc_7UW1Og3nhpQhHlvsTcvq9toGTw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Fri, 22 Oct 2010 14:52:40 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1010221726530.4510-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> Yeah, the new one is better.  I would have preferred
> to see fm_ili 
> explained in a comment, but this is okay.

Thanks. I tried to preserve the logic and the comments as much as possible and tried not to introduce neither additional comment nor additional logic. Is this an implicit ACK then? Or does Greg needs an explicit one?  Will he or I have to ask for an explicit ACK? From whom else?

