Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694Ab0HNO55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:57:57 -0400
Received: from smtp141.mail.ukl.yahoo.com ([77.238.184.72]:22512 "HELO
	smtp141.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756702Ab0HNO54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:57:56 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 10:57:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=iF+ek8PBVkj51I0pMz8KPxPfvSAbARpcId/AUwyhSrYIeQP4aK8gZFvqwIOhvioApOzNVN2C7KAcmNGs0rHjjFHQ3gIazPupAOscvKN4ZU79tcMTsYQHa+iNi/h9P1F7Zu9BICfM7yEs3Y/PcEyL9y4TrC0+EOqhz8oO0D0+qcI=  ;
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
X-YMail-OSG: 8JidJHYVM1lB5wVCemtbeHX8bAzoYTpG6KqfWom7j1HU.vP
 iQEfXKILfb_.3pPRmTbRXA3c_5nJePOne7rZrFe7Z852ohdmst_dTXJKvStn
 LSHhqkzcj7KePDZgF9tSGwTml9ascJ_NqtJjYBrS8QcgMhplhekBiDwPm0DK
 SJQ9eiC5oMDM.yWXCQaDpCUa0HXxozJXhJPnawwzyj7PTnTafg60LJonZdi.
 tC.8CuQW4oKzX4RZbjiBw1Du5ERmfp65_to2zuWiu3e8fB0o-
X-Yahoo-Newman-Property: ymail-3
From: Marek Lindner <lindner_marek@yahoo.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: batman-adv: design suggestions
Date: Sat, 14 Aug 2010 16:50:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus =?iso-8859-1?q?L=FCssing?= <linus.luessing@web.de>
References: <20100809203403.GA16183@albatros> <201008092254.39960.sven.eckelmann@gmx.de> <20100812124813.GB4881@albatros>
In-Reply-To: <20100812124813.GB4881@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008141650.57375.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 August 2010 14:48:13 Vasiliy Kulikov wrote:
> Is there any (un)official documentation/RFC/whatever of batman-adv
> protocol? I found only expired RFC of batman that is using UDP at
> www.open-mesh.org.

Yes, there is an unofficial one:
http://gitorious.org/batman-adv-doc

Note: This document is neither complete nor up to date. Writing proper 
documentation for the routing protocol is on our long ToDo list. 

The UDP version is very similar to the kernel module since we used the user 
space implementation to verify the concept.


Cheers,
Marek
