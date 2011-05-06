Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1EFIZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:25:51 -0400
Received: from web94913.mail.in2.yahoo.com ([203.104.17.184]:21965 "HELO
	web94913.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753966Ab1EFIZs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:25:48 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 04:25:48 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=W0AEHCbgphcCoIWfSfD+uySf0mynx3fGDCgxrLZGQvN0fsS7fx6sZnDIKeqbUOBpddZRF9VxNW2B2LKof6d8c+rED6Nz7Oyg90rLh1QfKeWs1x9myVHQ2hn230ofRtE2X1wDqMRuDpbKbdermxuI5BcIHK8mtyyXRooJDcoHCDc=;
Message-ID: <258099.79796.qm@web94913.mail.in2.yahoo.com>
X-YMail-OSG: 6v9P.oQVM1ni3juVMKCVwBy.HE0GlMdNrmZWEnbWB2fEO7n
 3JNdv_8P7WnSIRZbzhA.mgAGRWeCvc4uY1_.x_w5Z48z2YhItcEpTUN7i9YV
 VET9kkidCljGJMG.K5DfW_rxOiWMcj5dvFryq7lDAZpbwk9wzrb6RjDRjiVh
 Vk72i_Z6gwdE0sBkUxv_VxmXhyE3Fc3xDZ2.gqIKzHLnM65Bo5.g16t52Oaz
 Pf4djS_G4UIdpCzfEc4OKWElzud6Lrr8iF3qowIvzQ41xTMH2rZpt9DBTqfz
 3iVpIbK8woOfqllB4CZVsJGe8WdlDl9j6NdF3NsEqCYaQVJ0IK1xcWD405dJ
 vZFrvkpRQJn52nqm1HCWegAVDORTTv9uTNejBUrnyr33GIzvhf9UVeNPDZE_
 .tASxlaUS9ZCGYDSm9bloJc_Uexacoi2..QLFdKDekQA7dR0ey2N0_W3fff.
 69litPYKYlorKreKR9b_jZaaKpwJqcZPwk.dIOPFfXoqlbAasbKOqb1uoWuC
 Tq8M6KMuy8px8.XHBLotUfwJdRVsSLopD9vrNoiG.pOqW5oszhnWQ9ET5uEa
 4VncMxQ--
X-Mailer: YahooMailRC/559 YahooMailWebService/0.8.110.299900
Date: Fri, 6 May 2011 13:49:04 +0530 (IST)
From: Prashant Saxena <animator333@yahoo.com>
Subject: physical vs virtual mac address and mac address from NIC's firmware
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a newbie on linux and writing a small tool to get info of ethernet adapters 

installed. Please find more details and discussions in this post:
http://www.linuxforums.org/forum/programming-scripting/177222-physical-vs-virtual-mac-address-mac-address-nics-firmware.html#post842296



As the tool plays an important role in licensing system thus I need to make sure 

that solution should work
ideally on as many distros as possible. Considering the major and most commonly 
used distributions such as fedora, ubuntu, opensuse, debian etc. including their 

latest versions and bit older ones (3-4 years), what are the cons I might face 
using ethtool
api to get perma address?

BTW, you are kernel guys and I hoping that you might give me an answer for 
differentiating between physical and virtual adapters.

The details of my distribution including requirements of app is posted on the 
above mentioned topic.

Best Regards

Prashant
