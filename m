Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab1HLQLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:11:09 -0400
Received: from vip.anoweb.cz ([89.250.248.143]:59997 "EHLO smtp.anoweb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1HLQLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:11:06 -0400
X-Greylist: delayed 2163 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Aug 2011 12:11:06 EDT
Message-ID: <4E4548BC.9010108@strmilov.cz>
Date: Fri, 12 Aug 2011 17:37:32 +0200
From: Antonin Steinhauser <as@strmilov.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: TCP port firewall incl. description and english variable names
References: <1313161843-18226-1-git-send-email-as@strmilov.cz> <1313163276.2354.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1313163276.2354.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK
Dne 12.8.2011 17:34, Eric Dumazet napsal(a):
> Le vendredi 12 août 2011 à 17:10 +0200, Tonda a écrit :
>    
>> Module that is used to open, close or filter specified TCP port by
>> sending certain sequence of UDP packets to predefined UDP ports
>> (password-like firewall). One sequence of UDP ports is the opening key
>> and sending packets successively to them opens the TCP port and the
>> second sequence of UDP ports is the closing key and sending packets
>> successively to them closes the TCP port. If between two UDP packets
>> in the sequence comes more than 16 another UDP packets, the sequence
>> (either opening or closing) is aborted. The configuration and view of
>> affected TCP port, opening and closing key and other firewall
>> parameters is made throw use of sysfs.
>>
>> Signed-off-by: Antoine Steinhauser<as@strmilov.cz>
>>      
> Antoine
>
> There is no chance this can be added in official linux kernel, its
> really too ugly, and can be implemented using standard iptables rules,
> and userland controller, adding encryption and other high level stuff if
> needed.
>
>
>
>
>    

