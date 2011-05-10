Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1EJD5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:57:55 -0400
Received: from hm1315-19.locaweb.com.br ([201.76.49.149]:22414 "EHLO
	hm1315-19.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1EJD5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:57:54 -0400
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 May 2011 23:57:54 EDT
Message-ID: <4DC8B397.20207@taghos.com.br>
Date: Tue, 10 May 2011 00:40:07 -0300
From: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; pt-BR; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hch@infradead.org
Subject: XFS deadlock fixed?
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Mr. Hellwig,

    I saw the XFS deadlock thread regarding 2.6.38:

http://www.linux.sgi.com/archives/xfs/2011-03/msg00185.html

    I'm seeing too in 2.6.38.4. A lot of

XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)

    I checked the changelog for 2.6.38.6 and can't be sure if the fix got
in...could you tell me if it did?

    Thanks,

-- 

Felipe Wilhelms Damasio


TAGHOS - Tecnologia

Rua Prof. Alvaro Alvim, 211

Porto Alegre - RS - (51) 3239-3180

www.taghos.com.br <http://www.taghos.com.br/>


