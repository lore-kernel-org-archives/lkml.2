Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0D3Q6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:58:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0D3Q6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=v9BCcyUnCpYErZL9qli45NJStsY3FeaZhEs4e2EkX5EuEMGAlKpv9d0YgtAF9sXvfP
         lLrEA1lLEdr6cVHXL3ztqjsMVh1LVn2fHbi/N7hblIfn5sCyzYNgJnhriDI4f5BwCyEe
         IxFDj79BHVGdACMbknCmOy2zCF7b9hsbU7G4k=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed trailing whitespace style issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:56:36 +0530
Message-Id: <1272644796-8068-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes up all the
trailing whitespace errors found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |   82 ++++++++++++++++++------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 88fdd53..6e8821d 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -190,7 +190,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		while (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW))
 		{
 			if (READSHMB(arlan->resetFlag) ||
-				READSHMB(arlan->commandByte))	/* || 
+				READSHMB(arlan->commandByte))	/* ||
 								   (readControlRegister(dev) & ARLAN_ACCESS))
 								 */
 				udelay(40);
@@ -303,7 +303,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->card_polling_interval = HZ / 4;
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_RESET;
 		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE; 
+//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE;
 //		priv->waiting_command_mask |= ARLAN_COMMAND_RX;
 	}
 	else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK)
@@ -334,8 +334,8 @@ int arlan_command(struct net_device *dev, int command_p)
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_CONF;
 		priv->card_polling_interval = HZ / 10;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;   
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE; 
+//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
+//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE;
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF_WAIT;
 	}
 	else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT)
@@ -386,7 +386,7 @@ int arlan_command(struct net_device *dev, int command_p)
 	{
 		if (!test_and_set_bit(0, (void *) &priv->tx_command_given))
 		{
-			if (time_after(jiffies, 
+			if (time_after(jiffies,
 				       priv->tx_last_sent + us2ticks(conf->rx_tweak1))
 			    || time_before(jiffies,
 					   priv->last_rx_int_ack_time + us2ticks(conf->rx_tweak2)))
@@ -407,7 +407,7 @@ int arlan_command(struct net_device *dev, int command_p)
 				priv->tx_command_given = 0;
 				priv->card_polling_interval = 1;
 			}
-		} 
+		}
 		else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
 			printk(KERN_ERR "tx command when tx chain locked \n");
 	}
@@ -433,7 +433,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_SLOW_POLL;
 		priv->card_polling_interval = HZ / 3;
-	} 
+	}
 	else if (priv->waiting_command_mask & ARLAN_COMMAND_POWERDOWN)
 	{
 		setPowerOff(dev);
@@ -574,7 +574,7 @@ static void arlan_registration_timer(unsigned long data)
 			netif_wake_queue(dev);
 		if (time_after(priv->tx_last_sent,priv->tx_last_cleared) &&
 		    time_after(jiffies, priv->tx_last_sent * 5*HZ) ){
-			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);		
+			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 			priv->tx_last_cleared = jiffies;
 		}
 	}
@@ -853,20 +853,20 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	}
 	else
 		conf->radioNodeId = radioNodeId;
-		
+
 	if (SID == SIDUNKNOWN)
 	{
 		READSHM(conf->SID, arlan->SID, u_int);
 	}
 	else conf->SID = SID;
-		
+
 	if (spreadingCode == spreadingCodeUNKNOWN)
 	{
 		  READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
 	}
 	else
 		conf->spreadingCode = spreadingCode;
-		
+
 	if (channelSet == channelSetUNKNOWN)
 	{
 		READSHM(conf->channelSet, arlan->channelSet, u_char);
@@ -878,16 +878,16 @@ static int arlan_read_card_configuration(struct net_device *dev)
 		READSHM(conf->channelNumber, arlan->channelNumber, u_char);
 	}
 	else conf->channelNumber = channelNumber;
-	
+
 	READSHM(conf->scramblingDisable, arlan->scramblingDisable, u_char);
 	READSHM(conf->txAttenuation, arlan->txAttenuation, u_char);
-	
+
 	if (systemId == systemIdUNKNOWN)
 	{
 		READSHM(conf->systemId, arlan->systemId, u_int);
-	} 
+	}
 	else conf->systemId = systemId;
-	
+
 	READSHM(conf->maxDatagramSize, arlan->maxDatagramSize, u_short);
 	READSHM(conf->maxFrameSize, arlan->maxFrameSize, u_short);
 	READSHM(conf->maxRetries, arlan->maxRetries, u_char);
@@ -900,13 +900,13 @@ static int arlan_read_card_configuration(struct net_device *dev)
 		  READSHM(conf->SID, arlan->SID, u_int);
 	}
 	else conf->SID = SID;
-	
+
 	if (registrationMode == registrationModeUNKNOWN)
 	{
 		  READSHM(conf->registrationMode, arlan->registrationMode, u_char);
 	}
 	else conf->registrationMode = registrationMode;
-	
+
 	READSHM(conf->registrationFill, arlan->registrationFill, u_char);
 	READSHM(conf->localTalkAddress, arlan->localTalkAddress, u_char);
 	READSHM(conf->codeFormat, arlan->codeFormat, u_char);
@@ -921,16 +921,16 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(conf->headerSize, arlan->headerSize, u_short);
 	READSHM(conf->hardwareType, arlan->hardwareType, u_char);
 	READSHM(conf->radioType, arlan->radioModule, u_char);
-	
+
 	if (conf->radioType == 0)
 		conf->radioType = 0xc;
 
 	WRITESHM(arlan->configStatus, 0xA5, u_char);
 	READSHM(tlx415, arlan->configStatus, u_char);
-	
+
 	if (tlx415 != 0xA5)
 		printk(KERN_INFO "%s tlx415 chip \n", dev->name);
-	
+
 	conf->txClear = 0;
 	conf->txRetries = 1;
 	conf->txRouting = 1;
@@ -1054,7 +1054,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 	dev->tx_queue_len = tx_queue_len;
 	dev->netdev_ops = &arlan_netdev_ops;
 	dev->watchdog_timeo = 3*HZ;
-	
+
 	ap->irq_test_done = 0;
 	ap->Conf = &arlan_conf[num];
 
@@ -1065,7 +1065,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 
 	err = register_netdev(dev);
 	if (err) {
-		release_mem_region(virt_to_phys((void *) dev->mem_start), 
+		release_mem_region(virt_to_phys((void *) dev->mem_start),
 			   ARLAN_SHMEM_SIZE);
 		free_netdev(dev);
 		return err;
@@ -1075,7 +1075,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 	return 0;
 }
 
-static int __init arlan_probe_here(struct net_device *dev, 
+static int __init arlan_probe_here(struct net_device *dev,
 				   unsigned long memaddr)
 {
 	struct arlan_private *ap = netdev_priv(dev);
@@ -1085,7 +1085,7 @@ static int __init arlan_probe_here(struct net_device *dev,
 	if (arlan_check_fingerprint(memaddr))
 		return -ENODEV;
 
-	printk(KERN_NOTICE "%s: Arlan found at %llx, \n ", dev->name, 
+	printk(KERN_NOTICE "%s: Arlan found at %llx, \n ", dev->name,
 	       (u64) virt_to_phys((void*)memaddr));
 
 	ap->card = (void *) memaddr;
@@ -1138,7 +1138,7 @@ static int arlan_open(struct net_device *dev)
 	priv->txLast = 0;
 	priv->tx_command_given = 0;
 	priv->rx_command_given = 0;
-	
+
 	priv->reRegisterExp = 1;
 	priv->tx_last_sent = jiffies - 1;
 	priv->tx_last_cleared = jiffies;
@@ -1175,7 +1175,7 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned char *buf;
 
 	ARLAN_DEBUG_ENTRY("arlan_tx");
-	
+
 	length = ETH_ZLEN < skb->len ? skb->len : ETH_ZLEN;
 	buf = skb->data;
 
@@ -1299,7 +1299,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			}
 		}
 		break;
-		
+
 		case 2:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
@@ -1320,7 +1320,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			RetryOrFail(dev);
 		}
 		break;
-		
+
 		case 4:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
@@ -1343,7 +1343,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 
 		case 6:
 		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) 
+			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 				printk("arlan intr: transmit destination full\n");
 			priv->bad += 1;
 			priv->reset = 0;
@@ -1361,7 +1361,7 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 			arlan_queue_retransmit(dev);
 		}
 		break;
-		
+
 		case 8:
 		{
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
@@ -1479,7 +1479,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 						if (i == 6)
 							break;
 					}
-					/* we reach here if multicast filtering is on and packet 
+					/* we reach here if multicast filtering is on and packet
 					 * is multicast and not for receive */
 					goto end_of_interrupt;
 				}
@@ -1531,7 +1531,7 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 			dev->stats.rx_bytes += pkt_len;
 		}
 		break;
-		
+
 		default:
 			printk(KERN_ERR "arlan intr: received unknown status\n");
 			dev->stats.rx_crc_errors++;
@@ -1566,7 +1566,7 @@ static void arlan_process_interrupt(struct net_device *dev)
 
 		arlan_command(dev, ARLAN_COMMAND_INT_ACK);
 		arlan_command(dev, ARLAN_COMMAND_INT_ENABLE);
-		
+
 		IFDEBUG(ARLAN_DEBUG_INTERRUPT)
 			printk(KERN_ERR "%s:  got IRQ rx %x tx %x comm %x rxOff %x rxLen %x \n",
 					dev->name, rxStatus, txStatus, READSHMB(arlan->commandByte),
@@ -1657,7 +1657,7 @@ static irqreturn_t arlan_interrupt(int irq, void *dev_id)
 		priv->interrupt_ack_requested++;
 
 	arlan_process_interrupt(dev);
-	
+
 	priv->irq_test_done = 1;
 
 	ARLAN_DEBUG_EXIT("arlan_interrupt");
@@ -1775,7 +1775,7 @@ struct net_device * __init arlan_probe(int unit)
 	if (arlans_found == MAX_ARLANS)
 		return ERR_PTR(-ENODEV);
 
-	/* 
+	/*
 	 * Reserve space for local data and a copy of the shared memory
 	 * that is used by the /proc interface.
 	 */
@@ -1787,18 +1787,18 @@ struct net_device * __init arlan_probe(int unit)
 	if (unit >= 0) {
 		sprintf(dev->name, "eth%d", unit);
 		netdev_boot_setup_check(dev);
-		
+
 		if (dev->mem_start) {
 			if (arlan_probe_here(dev, dev->mem_start) == 0)
 				goto found;
 			goto not_found;
 		}
-			
+
 	}
 
 
-	for (m = (int)phys_to_virt(lastFoundAt) + ARLAN_SHMEM_SIZE; 
-	     m <= (int)phys_to_virt(0xDE000); 
+	for (m = (int)phys_to_virt(lastFoundAt) + ARLAN_SHMEM_SIZE;
+	     m <= (int)phys_to_virt(0xDE000);
 	     m += ARLAN_SHMEM_SIZE)
 	{
 		if (arlan_probe_here(dev, m) == 0)
@@ -1838,7 +1838,7 @@ int __init init_module(void)
 	for (i = 0; i < MAX_ARLANS; i++) {
 		struct net_device *dev = arlan_probe(i);
 
-		if (IS_ERR(dev)) 
+		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
 	init_arlan_proc();
@@ -1867,7 +1867,7 @@ void __exit cleanup_module(void)
 			arlan_command(dev, ARLAN_COMMAND_POWERDOWN );
 
 			unregister_netdev(dev);
-			release_mem_region(virt_to_phys((void *) dev->mem_start), 
+			release_mem_region(virt_to_phys((void *) dev->mem_start),
 					   ARLAN_SHMEM_SIZE);
 			free_netdev(dev);
 			arlan_device[i] = NULL;
-- 
1.6.0.4

