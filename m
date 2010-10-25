Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0JYPXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:23:33 -0400
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:43916 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752553Ab0JYPXc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:23:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=HG/H0IvRosOiZQPFMw2rC/wylJcRZb/iG1yiQPoRTblLLvFNoIgfsjBDrZfSyiSAJkGkKmILvAuos6U1kQVrzyNlVP95SfF246RuaBansYD/TfPfKGetS00CUNkMUJTMXAIBhMa0FZ46IViDVuDupehnt2fkGg90WGHn8EtHkWc=;
Message-ID: <88857.15062.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: O_sMyhcVM1mY6SaQfBmAyBTNhJXk.8mw2.PizK5k2uYoFmE
 Wo_DVDeM77ZiWIYpMxYuDF4XMUp8SVWBPNnpQolM0WCQzTWSXczOXmn68U6n
 n2178jnOsJN33tzXI4jQERxmdCLcNu4CAxQO6G4ftNEjAU_GbLLJIOydba2q
 I06v.Elbttb.TtMn9AIaAvXJXzTbam5vSe6lxDZpaXsiQSNg9wNjSpiRgFml
 FJTs3uoryoidgIV9S.vXALQUY.pyKGbt0F.TI5xzpKRMKav_N9KEKZODkUAi
 ETfQ_RLwvZ.X3rcVqqayqO4RQRaS5WVpq80QsoyynBvDGygIvkmdWICgz8Mr
 GUWqueeTl.RUhyTKSGNWR6g--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:23:31 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 09/29] memstick: rework state machines + attribute read function
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-10-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 09/29] memstick: rework state machines + attribute read function
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Code is rewritten to use new style of
> state machines.

As I said before:
1. Rationale for this "new style".
2. Human readable names for states and state transitions.
3. Coding style.


> Attribute read function is cleaned up and commented
> sparsely.
> 

Belongs to separate patch. Attribute read function is quite isolated from
everything else.




      
