Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0CRRMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:12:18 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:42930
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751027Ab0CRRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:12:16 -0400
Date: Thu, 18 Mar 2010 13:12:12 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node
 to get node pointer
Message-ID: <20100318131212.55bd7689@lappy.seanm.ca>
In-Reply-To: <20100318152238.21082.10985.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
	<20100318152238.21082.10985.stgit@angua>
Organization: PIKA
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 09:22:39 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> The following structure elements duplicate the information in
> 'struct device.of_node' and so are being eliminated.  This patches
> makes all readers of the following elements use device.of_node
> instead.

Acked-by: Sean MacLennan <smaclennan@pikatech.com>
