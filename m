Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1FHCjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:39:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1FHCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oEcRKZ/aNkhxojc0QdGME11MkWhIv8j3XdfSqcHkX7Y0ih/JO7Upkevs2oQAJFB6DB
         2VZpgmBueK4wIge22PddS1GKfLK0pZIX4FgsU2ZradKBvoVp/OpftvJ3Bj2LBCqMpO6h
         nkNgsPt8EbhPPR0EHikvJ5cij+HvgJLINAjvk=
Date: Wed, 8 Jun 2011 10:40:58 +0000
From: wangyanqing <udknight@gmail.com>
To: namhyung@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: doc?
Message-ID: <20110608104057.GA11680@ahead>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all!
Today when I look into dumpstack of x86,
I get %pB format specifier, and I don't
know what it is. But I can't find the information
from Documentation/printk-formats.txt. Yes, I
get the introduce from "git annotate and git log",
but I thinks It will be better if patches authors will 
add some documentation, right?
