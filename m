Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403Ab0HFHhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:37:25 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:29336 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933957Ab0HFHhV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:37:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=CdrEJ662IXfRDWlDlId59RC4SNHkAty2incvLWdbZuilwgVSdtBDxQiPEHyJ5l8SVVapUJxdT1hGoU83N56sJJh4d3gta1A9HHe2gJC/1/+tCVxKD9ni3rZ3OeDE3guxzZPlTIbIbxFHo3VbRvrTU46aJ9V13PILYAwD9q1o8wQ=;
Message-ID: <796642.31110.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: .LmUwBgVM1kTPTiaZTKh3n4B.9qPELsUf.mTeIfk1uxbJCj
 QIXvpIhvJO3U2djhIvTpZAMtRY39I8LmEmz.hbNLcoTkREyofQLOMx2h3fmC
 CulBqglTHCwl8dxEwvRr8SGz0pqBFa9sVfChckIr3Bs3WixmxYZTKlm06..q
 0OmvbyfJnYi72bANCQxJihB.BYVeN_BL0LRj2tY7uYSCRPi..8VBOfb114eB
 HkVqyP6qLJLu17U2wQb.C0v2mkew2qm0B9ZFJh.UDFMibkrYN3sqV6ZYm6CV
 ev6jZyHGaLtimwuK8IKdjpeKddhekN7ZADDJRj1M-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 6 Aug 2010 00:37:18 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281030536.23959.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> By 'spec mandated geometry' you mean the fact the card
> needs to be
> broken into zones, somewhat like XD?
> 

Yes, and in fancy fashion.

First zone should have at most 494 useful logical blocks, other zones - 496.
16 physical blocks per zone are considered local spares, 2 first blocks in
zone 1 must be identical and contain factory information.



      
