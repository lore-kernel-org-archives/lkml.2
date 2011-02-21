Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1BUOWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:22:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65129 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1BUOWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=n1AAlLUh6g6Asen+8aVna/wn+rRFjBYRyyipbhQROTIEMzrGjVGBfYcwAcuKzTDqOc
         BoIVzbspaqhYXnT1wXqjDA/ceuPgbEtIzv8212Pcr5K/k4b2AQoHhHGMXQ1NMTPg+ddu
         UR7ScsUUpIkGsZLAnMNdPACL81TumBmUYX2Sw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinDf2odDs2a9Wc0d4T8hxV6sj5GmgOs_p_3VHQP@mail.gmail.com>
References: <AANLkTinDf2odDs2a9Wc0d4T8hxV6sj5GmgOs_p_3VHQP@mail.gmail.com>
From: Erlon Cruz <sombrafam@gmail.com>
Date: Mon, 21 Feb 2011 11:21:25 -0300
Message-ID: <AANLkTimG7QacpnfC24QH9-QzQVTLT+xEU8Vhk1x6vq2Q@mail.gmail.com>
Subject: Re: Ftracing in linux kernel
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

   I've configured my kernel(2.6.35) to support ftrace*. Everything
seems to be ok. After I mounted the debugfs folder I can find all
tracing stuffs there. The problem is not of all functions on my module
seems to be listed in the funtions supported for tracing. In the file
available_filter_functions that suppose to list all functions traced,
only show 4 or 5 functions of my module. Does anyone knows why some
functions are not listed?

Regards,
Erlon

 *CONFIG_FUNCTION_TRACER
 CONFIG_FUNCTION_GRAPH_TRACER
 CONFIG_STACK_TRACER
 CONFIG_DYNAMIC_FTRACE
