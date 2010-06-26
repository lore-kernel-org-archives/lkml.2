Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0FZJAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:00:38 -0400
Received: from fep20.mx.upcmail.net ([62.179.121.40]:13264 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0FZJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:00:34 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C25C1AB.8010105@odi.ch>
Date: Sat, 26 Jun 2010 11:00:27 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: ata link not reset properly
References: <4C223F8A.9030306@odi.ch> <4C224429.6010705@kernel.org> <4C224502.2040206@kernel.org> <4C2305A8.4070708@odi.ch> <4C24C903.1070705@kernel.org> <4C24EED2.4020300@odi.ch> <4C257CEE.2070309@gmail.com>
In-Reply-To: <4C257CEE.2070309@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=/bZgxt9lcTTiCogXEfKVRpwqFqbGXHB0knonYiER/Vo= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=8nJEP1OIZ-IA:10 a=LUUpMNA6hXgJFLuLZQ4A:9 a=Wo03fh0N7DpOHcWFAbcJmGkA1QsA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.2010 06:07, Robert Hancock wrote:
> PATA doesn't normally use hard-resets as a means of error recovery -
> that would mean hitting the RESET line, which I don't think most
> controllers can do on software command 

Alright, no worries. I'll try to address the problem from the hardware side
then: cables, drives, etc.

Thanks.
  Ortwin
