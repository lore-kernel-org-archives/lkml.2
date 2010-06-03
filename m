Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab0FCJWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:22:41 -0400
Received: from smtp134.mail.ukl.yahoo.com ([77.238.184.65]:24707 "HELO
	smtp134.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751850Ab0FCJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:22:39 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 05:22:39 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=hH+Amhaqk2VSSwLm/8brcjB438vVJ5ZFMVxK32c4AqKtIFoIANzmsfiDHD9v+DPDdreokUpikP66jRIOkugWcrlg9yfOglK2YOZeOyecerEge7voQOlfH2GvGE79njL3WMm3B+tQRuUVJtohZYHjxqlPIdyBKB08dimbgw+Mqz8=  ;
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
X-YMail-OSG: kIJc334VM1lVkgnMNY_WwQULydkH0aVHSmkJyFEK6VzY_g8Wy7q8WqzhfTGraYw1u2uiKSLlF43zyOcB0I_wBnDk5P9hXyHGgkjJCQZkfohXc4.9GN60T811CaaeH3Tnn0rYbLvw4AAPyIVXoDFXTbykig1JX6d_Rc__I9Ov16fZEn0IsSLNr6Y99w.xiU_Z6MhyvQ8CWu8KiHeJ3xAcPXhz.CtZMzCCShNUTGRaqhuMvA--
X-Yahoo-Newman-Property: ymail-3
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Convert MAC_FMT to %pM
Date: Thu, 3 Jun 2010 17:15:53 +0800
User-Agent: KMail/1.13.3 (Linux/2.6.32-5-686; KDE/4.4.3; i686; ; )
Cc: Joe Perches <joe@perches.com>, Sven Eckelmann <sven.eckelmann@gmx.de>,
       devel <devel@driverdev.osuosl.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <1275509418.23599.42.camel@Joe-Laptop.home> <201006030156.42370.sven.eckelmann@gmx.de> <1275524401.23599.116.camel@Joe-Laptop.home>
In-Reply-To: <1275524401.23599.116.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031715.54584.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010 08:20:01 Joe Perches wrote:
> The patch changes the prefix from "batman-adv:" to "batman_adv: "
> so yes, it would break as-is.
> 
> I think the concept is broken though, I believe dmesg output
> specifically is not guaranteed to remain stable, and batman should
> use some other, perhaps private, logger based on ethtool events.

I think changing a dash to an underscore is not such a big deal (I did not 
check the rest of the patch yet). But I'm interested to hear more about your 
"private logger" idea because the current solution is far from being perfect. 
As we have to debug the routing protocol every now and then it would be very 
helpful to get direct access to some internal logging facility. In fact, that 
existed before (inside of /proc) but was removed to be more compliant with the 
linux kernel and the existing log facilities.

Regards,
Marek
